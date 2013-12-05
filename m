Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab3LEUKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:10:08 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:43239 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab3LEUKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:10:04 -0500
MIME-Version: 1.0
In-Reply-To: <20131205145217.GA23147@redhat.com>
References: <1386254181-17257-1-git-send-email-avagin@openvz.org>
 <1386254181-17257-2-git-send-email-avagin@openvz.org> <20131205145217.GA23147@redhat.com>
From: Michael Dalton <mwdalton@google.com>
Date: Thu, 5 Dec 2013 12:09:44 -0800
Message-ID: <CANJ5vPKoH59JuupkK5+dFD3irp8GQQ7MxCnV2GvPKxNYOXNgdA@mail.gmail.com>
Subject: Re: [PATCH 1/2] virtio-net: determine type of bufs correctly
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Andrey, great catch. I believe this issue occurs in one more
place, when packets are dropped if they are too short. I will send
out a patch momentarily to fix that additional case.

Best,

Mike
