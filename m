Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaDAOVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:21:23 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:56387 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaDAOVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:21:17 -0400
Date: Tue, 1 Apr 2014 11:19:42 -0300
From: Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        Ezequiel =?iso-8859-1?Q?Garc=EDa?= 
	<ezequiel@vanguardiasur.com.ar>,
        Walter Lozano <walter@vanguardiasur.com.ar>,
        Forest Bond <forest@alittletooquiet.net>
Subject: Re: [PATCH 3/3] staging: vt6655: fix checkpatch bracing issues
Message-ID: <20140401141942.GA8929@solid>
References: <1396356733-5344-1-git-send-email-guido@vanguardiasur.com.ar>
 <1396356733-5344-4-git-send-email-guido@vanguardiasur.com.ar>
 <20140401141302.GT6991@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140401141302.GT6991@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 05:13:02PM +0300, Dan Carpenter wrote:
> On Tue, Apr 01, 2014 at 09:52:13AM -0300, Guido Martínez wrote:
> > @@ -4285,14 +4252,9 @@ vMgrRxManagePacket(
> >  
> >  	case WLAN_FSTYPE_BEACON:
> >  		// Frame Clase = 0
> > -<<<<<<< HEAD
> > -		//DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "rx beacon\n");
> > -		if (pMgmt->eScanState != WMAC_NO_SCANNING) {
> > -=======
> >  		if (pMgmt->eScanState != WMAC_NO_SCANNING)
> > ->>>>>>> f3c59ed... staging: vt6655: remove dead code
> >  			bInScan = true;
> > -		}
> > +
> >  		s_vMgrRxBeacon(pDevice, pMgmt, pRxPacket, bInScan);
> >  		break;
> >  
> > @@ -4357,16 +4319,11 @@ bMgrPrepareBeaconToSend(
> >  	PSDevice            pDevice = (PSDevice)hDeviceContext;
> >  	PSTxMgmtPacket      pTxPacket;
> >  
> > -<<<<<<< HEAD
> > -//    pDevice->bBeaconBufReady = false;
> > -	if (pDevice->bEncryptionEnable || pDevice->bEnable8021x) {
> > -=======
> >  	if (pDevice->bEncryptionEnable || pDevice->bEnable8021x)
> > ->>>>>>> f3c59ed... staging: vt6655: remove dead code
> >  		pMgmt->wCurrCapInfo |= WLAN_SET_CAP_INFO_PRIVACY(1);
> > -	} else {
> > +	else
> >  		pMgmt->wCurrCapInfo &= ~WLAN_SET_CAP_INFO_PRIVACY(1);
> > -	}
> > +
> 
> Wat?

I seem to have messed up my rebase. Sorry about that. I'll send a v2
fixing this and with your suggestions applied.

Thanks,

-- 
Guido Martínez, VanguardiaSur
www.vanguardiasur.com.ar
