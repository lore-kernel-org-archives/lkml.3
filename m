Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab3HIENN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 00:13:13 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:38086 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3HIENL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 00:13:11 -0400
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTwvnOIZoM
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [ 000/102] 3.10.6-stable review
Date: Fri, 9 Aug 2013 06:13:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-5.slh.2-aptosid-686; KDE/4.8.4; i686; ; )
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20130809015010.208118575@linuxfoundation.org>
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201308090613.06774.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 09 August 2013, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.6 release.
[…]
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
[…]

There appears to be a problem with the mirroring (not pushed?):

$ LANG= wget kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
--2013-08-09 06:05:02--  http://kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
Resolving kernel.org (kernel.org)... 149.20.4.69, 198.145.20.140
Connecting to kernel.org (kernel.org)|149.20.4.69|:80... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: https://www.kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz [following]
--2013-08-09 06:05:02--  https://www.kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
Resolving www.kernel.org (www.kernel.org)... 198.145.20.140, 149.20.4.69
Connecting to www.kernel.org (www.kernel.org)|198.145.20.140|:443... connected.
HTTP request sent, awaiting response... 404 Not Found
2013-08-09 06:05:06 ERROR 404: Not Found.

The other -stable patches of this round
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.57-rc1.gz
and
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.90-rc1.gz
appear to be missing as well.

Using the current queue-3.10/series from 
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
builds and works fine on x86_64 and i386.

Regards
	Stefan Lippers-Hollmann
