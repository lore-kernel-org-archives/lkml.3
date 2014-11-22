Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaKVXHo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 18:07:44 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:39764 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaKVXHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 18:07:43 -0500
X-Originating-IP: 50.43.41.112
Date: Sat, 22 Nov 2014 15:07:32 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Pieter Smith <pieter@boesman.nl>
Cc: Willem de Bruijn <willemb@google.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Thomas Graf <tgraf@suug.ch>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Daniel Borkmann <dborkman@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        open list <linux-kernel@vger.kernel.org>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tom Herbert <therbert@google.com>
Subject: Re: [PATCH 5/6] net/core: support compiling out splice
Message-ID: <20141122230731.GC24429@thin>
References: <1416690001-20817-1-git-send-email-pieter@boesman.nl>
 <1416690001-20817-6-git-send-email-pieter@boesman.nl>
 <20141122214853.GB23711@thin>
 <CAPho-_+GV+2sVVxGsPSjvE3heEoGa4chbqrmnxLAr_p7RU=TDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPho-_+GV+2sVVxGsPSjvE3heEoGa4chbqrmnxLAr_p7RU=TDQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please don't top-post.]

On Sat, Nov 22, 2014 at 11:50:51PM +0100, Pieter Smith wrote:
> splice exports a structure that is used by skbuf. Mocking out a function is
> straightforward. To my knowledge there is no elegant way of mocking out a
> splice_operations struct. I directly modified the code to prevent linking
> against the struct. Do you know of a better technique to get the same
> result?

No, I don't.  The approach you took seems fine; I'm just saying that you
need to explain the need for it in the commit message.

- JosH Triplett
