Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3KWKt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 05:49:28 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:54681 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3KWKtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 05:49:24 -0500
Message-ID: <52909685.6040606@kernel.org>
Date: Sat, 23 Nov 2013 11:50:29 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>, linux-iio@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@cam.ac.uk>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio:light:tsl2563: Add DT support
References: <1382565063-17083-1-git-send-email-sre@debian.org> <20131025191028.8C140C40422@trevor.secretlab.ca> <20131025230906.GB8657@earth.universe>
In-Reply-To: <20131025230906.GB8657@earth.universe>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/26/13 00:09, Sebastian Reichel wrote:
> Hi Grant,
> 
> On Fri, Oct 25, 2013 at 08:10:28PM +0100, Grant Likely wrote:
>>> +  - cover-comp-gain : integer used as multiplier for gain +                      compensation (default = 1)
>> 
>> Should be taos,cover-comp-gain
> 
> Has been updated to "amstaos,cover-comp-gain" in the latest patches, see https://lkml.org/lkml/2013/10/25/59
> 
>> Otherwise looks fine to me.
> 
> Is this an acked-by?
It's good enough for me to take the patch  :)
> 
>>> +	else if (np) +		of_property_read_u32_index(np, "cover-comp-gain", 0, +							&chip->cover_comp_gain);
>> 
>> of_property_read_u32() should be sufficient. You don't need the _index variant.
> 
> ah, I missed the function when skipping over linux/of.h. I will sent another update.
Did you do this?  Latest I seem to have is V3 and that doesn't have
this change.  I've made the obvious change to your V3 and applied it.

Thanks,

Jonathan
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSkJaFAAoJEFSFNJnE9BaI3MAP/RJhSwcTn54E2bOwPzipVbFY
mEBHnth2qNFTv2xrDobI1xDKaaBWzDdnuYHfNmUshO8rJMFv7UgLWIOhSRlSues9
RHindDLt2t4xl9F2PufQDe66RFzcchqe6PB0+PxwKdSt/tVArP0UnPInMM2vCrqD
k5HPhHgrkbNgBp4y2GyMjnYyQ4bbh+/bUBNQZ+9z0DD7vYqJXqzhywMPnfidM6i5
M5+Fp2COuoJuD4lUI+ccxQVdPYmDiPXPbj95JI8wFebcNie3vyyrkKCfeLm87by9
sK9jEm3n3IGUFOi4w4/7ToMtY/DmLdyhHvRmmnHvD1n4D0VZYVeRZmBeyNyIGv9s
qXpasLgDbFrd1OEQwwYVMCoG6NKqvb67XCS1h58MAQqKnwq6PvQJGIFEFw7raiit
bumIIwkiYqyqHEoLA34fG1Y9eB9SoMfMtMelzwGBty65kDzEy/9rl1nK4Z7lVguj
O1+oMPOW3vK8UiOQ71MqZGd0bqOx0axQDbPMhXt4jo98vNFmNZ8Jboaof7cmJ38R
eDtCZ4YfbtUXdSTqnGN1GLnxexAdja8HbnKKQfR6oN+Oy7o4cqFsTdj+TsL2+4/R
EAhNZSWQm2R8QTyETwL9n/F9vRTQWT8B3kcWGY3qhepnQzWD4k5neGOBFe3kUQQ6
EvUmHyPCWeCmqcnlgoZz
=f7mV
-----END PGP SIGNATURE-----
