Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab3IATgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 15:36:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38435 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753394Ab3IATgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 15:36:40 -0400
Message-ID: <1378064198.1953.17.camel@joe-AO722>
Subject: Re:  [staging] Staging: Convert uses of compare_ether_addr to
 ether_addr_equal
From: Joe Perches <joe@perches.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 01 Sep 2013 12:36:38 -0700
In-Reply-To: <522395c4.hZ2B3PrpTjC+j1oP%wangshilong1991@gmail.com>
References: <522395c4.hZ2B3PrpTjC+j1oP%wangshilong1991@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-02 at 03:30 +0800, Wang Shilong wrote:
> Hello, Using checkpatch.pl, i get the following warnings(errors):

Hello.

Especially for staging patches, all of these are "don't care"
types of messages.

You should change your script to check if these are existing
warnings and if so, not bother reporting them.

> WARNING: Avoid CamelCase: <pstats->bHwError>
> #124: FILE: drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c:1875:
> +		 (!pstats->bHwError) && (!pstats->bCRC) && (!pstats->bICV));
> 
> WARNING: Avoid CamelCase: <pstats->bCRC>
> #124: FILE: drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c:1875:
> +		 (!pstats->bHwError) && (!pstats->bCRC) && (!pstats->bICV));
> 
> WARNING: Avoid CamelCase: <pstats->bICV>
> #124: FILE: drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c:1875:
> +		 (!pstats->bHwError) && (!pstats->bCRC) && (!pstats->bICV));
> 
> WARNING: line over 80 characters
> #185: FILE: drivers/staging/slicoss/slicoss.c:795:
> +						     ether_frame->ether_dhost)) {
> 
> WARNING: Avoid CamelCase: <pCurrBSS->abyBSSID>
> #207: FILE: drivers/staging/vt6655/bssdb.c:151:
> +				if (ether_addr_equal(pCurrBSS->abyBSSID,
> 
> WARNING: Avoid CamelCase: <pbyBSSID>
> #208: FILE: drivers/staging/vt6655/bssdb.c:152:
> +						     pbyBSSID)) {
> 
> WARNING: Avoid CamelCase: <pMgmt->sBSSList[ii].abyBSSID>
> #217: FILE: drivers/staging/vt6655/bssdb.c:279:
> +			    ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
> 
> WARNING: Avoid CamelCase: <pMgmt->abyCurrBSSID>
> #218: FILE: drivers/staging/vt6655/bssdb.c:280:
> +					     pMgmt->abyCurrBSSID)) {
> 
> WARNING: Avoid CamelCase: <pBSSList->abyBSSID>
> #227: FILE: drivers/staging/vt6655/bssdb.c:323:
> +			if (ether_addr_equal(pBSSList->abyBSSID, abyBSSID)) {
> 
> WARNING: Avoid CamelCase: <abyBSSID>
> #227: FILE: drivers/staging/vt6655/bssdb.c:323:
> +			if (ether_addr_equal(pBSSList->abyBSSID, abyBSSID)) {
> 
> WARNING: Avoid CamelCase: <abyDstAddr>
> #236: FILE: drivers/staging/vt6655/bssdb.c:738:
> +			if (ether_addr_equal(abyDstAddr,
> 
> WARNING: line over 80 characters
> #237: FILE: drivers/staging/vt6655/bssdb.c:739:
> +					     pMgmt->sNodeDBTable[ii].abyMACAddr)) {
> 
> WARNING: Avoid CamelCase: <pMgmt->sNodeDBTable[ii].abyMACAddr>
> #237: FILE: drivers/staging/vt6655/bssdb.c:739:
> +					     pMgmt->sNodeDBTable[ii].abyMACAddr)) {
> 
> WARNING: Avoid CamelCase: <pbyRxBuffer>
> #250: FILE: drivers/staging/vt6655/dpc.c:175:
> +	if (ether_addr_equal(pbyRxBuffer, pDevice->abySNAP_Bridgetunnel)) {
> 
> WARNING: Avoid CamelCase: <pDevice->abySNAP_Bridgetunnel>
> #250: FILE: drivers/staging/vt6655/dpc.c:175:
> +	if (ether_addr_equal(pbyRxBuffer, pDevice->abySNAP_Bridgetunnel)) {
> 
> WARNING: Avoid CamelCase: <pDevice->sRxEthHeader.abySrcAddr>
> #262: FILE: drivers/staging/vt6655/dpc.c:423:
> +	if (ether_addr_equal(pDevice->sRxEthHeader.abySrcAddr,
> 
> WARNING: Avoid CamelCase: <pDevice->abyCurrentNetAddr>
> #263: FILE: drivers/staging/vt6655/dpc.c:424:
> +			     pDevice->abyCurrentNetAddr))
> 
> WARNING: line over 80 characters
> #276: FILE: drivers/staging/vt6655/iwctl.c:666:
> +				    ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
> 
> WARNING: Avoid CamelCase: <pMgmt->abyDesireBSSID>
> #277: FILE: drivers/staging/vt6655/iwctl.c:667:
> +						     pMgmt->abyDesireBSSID)) {
> 
> WARNING: line over 80 characters
> #286: FILE: drivers/staging/vt6655/iwctl.c:844:
> +						    ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
> 
> WARNING: line over 80 characters
> #287: FILE: drivers/staging/vt6655/iwctl.c:845:
> +								     pCurr->abyBSSID)) {
> 
> WARNING: Avoid CamelCase: <pCurr->abyBSSID>
> #287: FILE: drivers/staging/vt6655/iwctl.c:845:
> +								     pCurr->abyBSSID)) {
> 
> WARNING: Avoid CamelCase: <pTable->KeyTable[i].abyBSSID>
> #300: FILE: drivers/staging/vt6655/key.c:144:
> +		    ether_addr_equal(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
> 
> WARNING: Avoid CamelCase: <pDevice->abyBSSID>
> #389: FILE: drivers/staging/vt6655/wpactl.c:397:
> +			if (ether_addr_equal(param->addr, pDevice->abyBSSID)) {
> 
> WARNING: suspect code indent for conditional statements (12, 20)
> #399: FILE: drivers/staging/vt6656/bssdb.c:127:
>              if ((pCurrBSS->bActive) &&
> [...]
> +		    if (ether_addr_equal(pCurrBSS->abyBSSID, pbyBSSID)) {
> 
> WARNING: suspect code indent for conditional statements (20, 20)
> #402: FILE: drivers/staging/vt6656/bssdb.c:129:
> +		    if (ether_addr_equal(pCurrBSS->abyBSSID, pbyBSSID)) {
>                      if (pSSID != NULL) {
> 
> WARNING: suspect code indent for conditional statements (16, 16)
> #422: FILE: drivers/staging/vt6656/bssdb.c:280:
> +		if (ether_addr_equal(pBSSList->abyBSSID, abyBSSID)) {
>                  if (pSSID->len == ((PWLAN_IE_SSID)pBSSList->abySSID)->len){
> 
> WARNING: suspect code indent for conditional statements (16, 16)
> #432: FILE: drivers/staging/vt6656/bssdb.c:626:
> +		if (ether_addr_equal(abyDstAddr,
> [...]
>                  *puNodeIndex = ii;
> 
> WARNING: please, no spaces at the start of a line
> #446: FILE: drivers/staging/vt6656/dpc.c:139:
> +    if (ether_addr_equal(pbyRxBuffer, pDevice->abySNAP_Bridgetunnel)) {$
> 
> WARNING: please, no spaces at the start of a line
> #449: FILE: drivers/staging/vt6656/dpc.c:141:
> +    } else if (ether_addr_equal(pbyRxBuffer, pDevice->abySNAP_RFC1042)) {$
> 
> WARNING: suspect code indent for conditional statements (7, 9)
> #456: FILE: drivers/staging/vt6656/dpc.c:363:
>         if (pMgmt->sNodeDBTable[0].bActive) {
> +	 if (ether_addr_equal(pMgmt->abyCurrBSSID, pMACHeader->addr2)) {
> 
> WARNING: suspect code indent for conditional statements (9, 12)
> #458: FILE: drivers/staging/vt6656/dpc.c:364:
> +	 if (ether_addr_equal(pMgmt->abyCurrBSSID, pMACHeader->addr2)) {
>  	    if (pMgmt->sNodeDBTable[0].uInActiveCount != 0)
> 
> WARNING: braces {} are not necessary for single statement blocks
> #468: FILE: drivers/staging/vt6656/dpc.c:377:
> +	if (!ether_addr_equal(pDevice->abyCurrentNetAddr, pMACHeader->addr1)) {
>  		return false;
>          }
> 
> WARNING: please, no spaces at the start of a line
> #478: FILE: drivers/staging/vt6656/dpc.c:385:
> +    if (ether_addr_equal((u8 *)pDevice->sRxEthHeader.h_source,$
> 
> WARNING: Avoid CamelCase: <pDevice->sRxEthHeader.h_source>
> #478: FILE: drivers/staging/vt6656/dpc.c:385:
> +    if (ether_addr_equal((u8 *)pDevice->sRxEthHeader.h_source,
> 
> WARNING: line over 80 characters
> #493: FILE: drivers/staging/vt6656/iwctl.c:660:
> +					ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
> 
> WARNING: line over 80 characters
> #494: FILE: drivers/staging/vt6656/iwctl.c:661:
> +							 pMgmt->abyDesireBSSID)) {
> 
> WARNING: line over 80 characters
> #504: FILE: drivers/staging/vt6656/iwctl.c:843:
> +						ether_addr_equal(pMgmt->sBSSList[ii].abyBSSID,
> 
> WARNING: line over 80 characters
> #505: FILE: drivers/staging/vt6656/iwctl.c:844:
> +								 pCurr->abyBSSID)) {
> 
> total: 0 errors, 39 warnings, 400 lines checked
> 
> patch has style problems, please review.
> 
> If any of these errors are false positives, please report
> them to the maintainer, see CHECKPATCH in MAINTAINERS.
> 
> Thanks, Wang
> 
> Notice: this is an automatically generated by shell script
> Any problems please contact: wangshilong1991@gmail.com
> 



