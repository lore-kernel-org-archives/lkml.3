Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab3KEHDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 02:03:39 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:60390 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3KEHDi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 02:03:38 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Noam Camus <noamc@ezchip.com>,
        greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] Critical ARC Fix for 3.12
Thread-Topic: [PATCH] Critical ARC Fix for 3.12
Thread-Index: AQHO18WbsuskSvVT90u/qJDX934fQg==
Date: Tue, 5 Nov 2013 07:03:33 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075155522@IN01WEMBXA.internal.synopsys.com>
References: <1383394669-20175-1-git-send-email-vgupta@synopsys.com>
 <CAMuHMdV-PXujh_vf_rwz7-bAi7wBaSL+9tWixvWnpWXr7skKZA@mail.gmail.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2013 03:59 PM, Geert Uytterhoeven wrote:
> Added CC stable, so Greg will see it.
> Added commit 9c41f4eeb9d51f3ece20428d35a3ea32cf3b5622, so Greg knows
> what to cherry-pick.

Thanks Geert. While cover-letter was not, the patch itself was CC'ed to stable -
this cover letter, with PATCH prefix has caused enough confusion already :-(

Greg, I have verified that patch builds fine with 3.10 and 3.11. Please take it.

-Vineet
