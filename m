Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaLZWk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 17:40:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:39239 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaLZWk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 17:40:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,649,1413270000"; 
   d="scan'208";a="629540472"
User-Agent: Microsoft-MacOutlook/14.4.6.141106
Date: Fri, 26 Dec 2014 14:40:24 -0800
Subject: Re: [PATCH 2/2] merge_config.sh: add -? for help
From: Darren Hart <dvhart@linux.intel.com>
To: Olof Johansson <olof@lixom.net>, <yann.morin.1998@free.fr>
CC: <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <D0C32312.B56B7%dvhart@linux.intel.com>
Thread-Topic: [PATCH 2/2] merge_config.sh: add -? for help
References: <1418331304-4821-1-git-send-email-olof@lixom.net>
 <1418331304-4821-2-git-send-email-olof@lixom.net>
In-Reply-To: <1418331304-4821-2-git-send-email-olof@lixom.net>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No objection to the addition of -? if you find it useful.

Acked-by: Darren Hart <dvhart@linux.intel.com>

-- 
Darren Hart
Intel Open Source Technology Center




On 12/11/14, 12:55 PM, "Olof Johansson" <olof@lixom.net> wrote:

>It's usual enough for help text that it makes sense to support it.
>
>Signed-off-by: Olof Johansson <olof@lixom.net>
>---
> scripts/kconfig/merge_config.sh |   12 ++++++------
> 1 file changed, 6 insertions(+), 6 deletions(-)
>
>diff --git a/scripts/kconfig/merge_config.sh
>b/scripts/kconfig/merge_config.sh
>index 2ab91b9..0c89537 100755
>--- a/scripts/kconfig/merge_config.sh
>+++ b/scripts/kconfig/merge_config.sh
>@@ -28,11 +28,11 @@ trap clean_up HUP INT TERM
> 
> usage() {
> 	echo "Usage: $0 [OPTIONS] [CONFIG [...]]"
>-	echo "  -h    display this help text"
>-	echo "  -m    only merge the fragments, do not execute the make command"
>-	echo "  -n    use allnoconfig instead of alldefconfig"
>-	echo "  -r    list redundant entries when merging fragments"
>-	echo "  -O    dir to put generated output files"
>+	echo "  -h or -? display this help text"
>+	echo "  -m       only merge the fragments, do not execute the make
>command"
>+	echo "  -n       use allnoconfig instead of alldefconfig"
>+	echo "  -r       list redundant entries when merging fragments"
>+	echo "  -O       dir to put generated output files"
> }
> 
> MAKE=true
>@@ -52,7 +52,7 @@ while true; do
> 		shift
> 		continue
> 		;;
>-	"-h")
>+	"-h"|"-?")
> 		usage
> 		exit
> 		;;
>-- 
>1.7.10.4
>


