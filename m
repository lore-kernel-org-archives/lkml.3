Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbaJABCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 21:02:33 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.142]:55940 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbaJABCc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 21:02:32 -0400
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-13.tower-179.messagelabs.com!1412125349!35924590!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.12.2; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [James Seong-Won Ban]" <James.Ban.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <Support.Opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "David Dajun Chen" <david.chen@diasemi.com>
Subject: RE: [PATCH V1] regulator: DA9211 : Fix a bug in update of mask bit
Thread-Topic: [PATCH V1] regulator: DA9211 : Fix a bug in update of mask bit
Thread-Index: AQHP3FwbgZHlzhXEZE+tQL/X8ctFBpwZj1AAgADbS3A=
Date: Wed, 1 Oct 2014 01:02:27 +0000
Message-ID: <0ACAE736BB7A70499F1D8D5E6AC1854C01AC2AF92C@SW-EX-MBX01.diasemi.com>
References: <201409300310.s8U3AUfe031634@krsrvapps-01.diasemi.com>
 <20140930124522.GE4273@sirena.org.uk>
In-Reply-To: <20140930124522.GE4273@sirena.org.uk>
Accept-Language: ko-KR, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.95.26.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 30, 2014 9:45 PM Mark Brown wrote:

> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Tuesday, September 30, 2014 9:45 PM
> To: Opensource [James Seong-Won Ban]
> Cc: Liam Girdwood; Support Opensource; LKML; David Dajun Chen
> Subject: Re: [PATCH V1] regulator: DA9211 : Fix a bug in update of mask bit
> 
> On Mon, Sep 29, 2014 at 04:59:20PM +0900, James Ban wrote:
> > This is a patch for fixing a bug about mask bit operation.
> 
> Applied, but please try to make sure that your changelogs are more
> descriptive - what is the bug?  Please also use subject lines matching
> the style for the subsystem.
The proper operation of mask bit should be set as '0' for enabling the interrupt.
The result of mask operation at previous code was the same to new one.
But the meaning in the previous code was to set mask bit as '1'.
What is subject line you said?
If you give me an example, it would be very helpful to me.

Regards,
James
