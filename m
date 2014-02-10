Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaBJOHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:07:07 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:59760 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaBJOHC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:07:02 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Paul Bolle <pebolle@tiscali.nl>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 27/28] Remove ARC_HAS_COH_RTSC
Thread-Topic: [PATCH 27/28] Remove ARC_HAS_COH_RTSC
Thread-Index: AQHPJmbB8Td5TdPR/UGwp+tcC5L9vg==
Date: Mon, 10 Feb 2014 14:06:54 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307517B8BC@IN01WEMBXA.internal.synopsys.com>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
		 <1391971686-9517-28-git-send-email-richard@nod.at>
	 <1391975219.25855.8.camel@x220> <52F85707.9000901@synopsys.com>
 <1392040100.3585.18.camel@x220>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.197.80]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 February 2014 07:18 PM, Paul Bolle wrote:
> On Mon, 2014-02-10 at 10:05 +0530, Vineet Gupta wrote:
>> On Monday 10 February 2014 01:16 AM, Paul Bolle wrote:
>>> This Kconfig symbol was removed in commit 7d087a54aed ("ARC: [SMP]
>>> Disallow RTSC"), merged in v3.13.
>> I've applied you ACK, with the fixed commit-id 7d0857a54aed
> Manually trimming 40 hex digits down to 12 digits. What can go wrong?

Yes pretty weird - one intermediate char got eaten somehow.


