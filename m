Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbaJVS2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:28:33 -0400
Received: from tex.lwn.net ([70.33.254.29]:51267 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbaJVS23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:28:29 -0400
Date: Wed, 22 Oct 2014 14:28:26 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Kirill Smelkov <kirr@nexedi.com>
Cc: Ken Chen <kenchen@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RESEND] hugetlbfs: document that sticky mounts are
 allowed
Message-ID: <20141022142826.109c27cc@lwn.net>
In-Reply-To: <20141022155446.GA20240@teco.navytux.spb.ru>
References: <1409836833-4320-1-git-send-email-kirr@nexedi.com>
	<CABQzsv_9K0WrddMW60DkUbsv2B5BwLNFCES2TNvfVNaG-ym6YA@mail.gmail.com>
	<20141022155446.GA20240@teco.navytux.spb.ru>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014 19:54:46 +0400
Kirill Smelkov <kirr@nexedi.com> wrote:

> Please apply the below patch documenting that hugetlbfs can be sticky-mounted.

It documents it in a rather obscure way...but, then, to be clear, that
document needs a lot of help in general.

Applied.  Redundant Cc tag removed.

Thanks,

jon
