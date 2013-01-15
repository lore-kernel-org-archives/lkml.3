Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab3AOPH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:07:29 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:58596 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab3AOPH2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:07:28 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ido Yariv <ido@wizery.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Date: Tue, 15 Jan 2013 16:07:10 +0100
Subject: RE: [RFCv2 03/11] remoteproc: Set vring addresses in resource table
Thread-Topic: [RFCv2 03/11] remoteproc: Set vring addresses in resource table
Thread-Index: Ac3fINrwBSVMAC5MRJubq9RhJpjD6APU7wOg
Message-ID: <81C3A93C17462B4BBD7E272753C1057924588EE055@EXDCVYMBSTM005.EQ1STM.local>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-4-git-send-email-sjur.brandeland@stericsson.com>
 <20121221021358.GA28692@WorkStation.localnet>
In-Reply-To: <20121221021358.GA28692@WorkStation.localnet>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ido,
> > Set the vring addresses in the resource table so that
> > the remote device can read the actual addresses used.
> >
> > Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> 
> Since this new member will only be referenced in the last patch, perhaps
> squash the two patches?

This patch fixes two TODOs in the remoteproc_core.c so I think
it deserves to be a separate patch.

Regards,
Sjur
