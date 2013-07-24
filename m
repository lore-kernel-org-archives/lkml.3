Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3GXWN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:13:29 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.108]:59173 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753670Ab3GXWN0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:13:26 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-160.messagelabs.com!1374704002!6772291!11
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ian Abbott <abbotti@mev.co.uk>
Date: Wed, 24 Jul 2013 17:11:25 -0500
Subject: RE: [PATCH 22/36] staging: comedi: convert class code to use
 dev_groups
Thread-Topic: [PATCH 22/36] staging: comedi: convert class code to use
 dev_groups
Thread-Index: Ac6Iuf0+03LeC4NdQRqJZWexzkyiZwAAIaCA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DAC5C1F40@AUSP01VMBX24.collaborationhost.net>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
 <1374703539-9705-23-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1374703539-9705-23-git-send-email-gregkh@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 24, 2013 3:05 PM, Greg Kroah-Hartman wrote:
>
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the comedi class code to use the
> correct field.
>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/staging/comedi/comedi_fops.c | 39 ++++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 19 deletions(-)

Looks good to me. Not sure what my sign off should be so take your pick.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>




