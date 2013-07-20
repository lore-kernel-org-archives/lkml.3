Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab3GTARY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 20:17:24 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:15388 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3GTARW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 20:17:22 -0400
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTyOLSIpvIeg==
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [ 00/72] 3.10.2-stable review
Date: Sat, 20 Jul 2013 02:17:14 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-0.slh.2-aptosid-686; KDE/4.8.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20130719052559.852627424@linuxfoundation.org>
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201307200217.19248.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 19 July 2013, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.2 release.
[…]
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.2-rc1.gz
> and the diffstat can be found below.

Minor nit, this introduces trailing whitespace in "SUBLEVEL = 2 ".

[…]
diff --git a/Makefile b/Makefile
index b75cc30..9b47ed3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 10
-SUBLEVEL = 1
-EXTRAVERSION =
+SUBLEVEL = 2 
+EXTRAVERSION = -rc1
 NAME = Unicycling Gorilla
 
 # *DOCUMENTATION*
[…]

3.9.11-rc1, 3.4.54-rc1 and 3.0.87-rc1 are not affected.

Thank you a lot for your efforts of -stable maintenance!

Regards
	Stefan Lippers-Hollmann
