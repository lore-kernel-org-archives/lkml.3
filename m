Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934376Ab3CMWlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 18:41:14 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:65007 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932547Ab3CMWlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 18:41:13 -0400
Message-ID: <1363214471.1335.19.camel@x61.thuisdomein>
Subject: Re: [PATCH] mtd: remove ixp2000 driver
From: Paul Bolle <pebolle@tiscali.nl>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 13 Mar 2013 23:41:11 +0100
In-Reply-To: <1363206974.1335.10.camel@x61.thuisdomein>
References: <1363206974.1335.10.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Mar 2013 22:41:11.0717 (UTC) FILETIME=[DCA34550:01CE203B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-13 at 21:36 +0100, Paul Bolle wrote:
> Support for the IXP2000 platform got removed in commit
> c65f2abf54a6d07260f1fa64773154e1d7047961 ("ARM: remove ixp23xx and
> ixp2000 platforms"). That commit removed the ARCH_IXP2000 Kconfig
> symbol. This removes the last driver depending on that symbol.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

It turns out that Artem Bityutskiy has published a series of patches
removing this and similar drivers just yesterday:
http://lists.infradead.org/pipermail/linux-mtd/2013-March/046170.html 

A quick scan suggest that's all great stuff! Anyhow, my patch can be
ignored.


Paul Bolle

