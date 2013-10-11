Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab3JKHFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:05:14 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.99]:46551 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3JKHFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:05:12 -0400
Message-ID: <5257A320.1070207@ladisch.de>
Date: Fri, 11 Oct 2013 09:05:04 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stanimir Varbanov <svarbanov@mm-sol.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 0/2] Add support for Qualcomm's PRNG
References: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com> <20131003165130.GA11974@thunk.org> <524EEB96.6040707@mm-sol.com> <20131004181005.GA7022@thunk.org> <52556C4E.9000604@mm-sol.com> <52557137.5050200@zytor.com> <5256AFFE.5090605@mm-sol.com>
In-Reply-To: <5256AFFE.5090605@mm-sol.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanimir Varbanov wrote:
> I ran the rngtest with following command line:
>
> # cat /dev/hw_random | rngtest -c 100000
> ...
> rngtest: bits received from input: 2000000032
> rngtest: FIPS 140-2 successes: 99925
> rngtest: FIPS 140-2 failures: 75
> ...
>
> Could you guys comment those results?

These tests are expected to fail a few times even for perfectly random
data (think monkeys/Shakespeare).  An entropy source will be permanently
disabled by rngd only if the failure ratio is worse than 1 in 1000.


Regards,
Clemens
