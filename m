Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbaIDWQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 18:16:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39152 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665AbaIDWQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 18:16:40 -0400
Message-ID: <5408E4A3.2060303@zytor.com>
Date: Thu, 04 Sep 2014 15:16:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Jakub Jelinek <jakub@redhat.com>, Mikael Pettersson <mikpelinux@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Richard Henderson <rth@twiddle.net>, Oleg Nesterov <oleg@redhat.com>,
        Miroslav Franc <mfranc@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        linux-ia64@vger.kernel.org
Subject: Re: bit fields && data tearing
References: <20140712181328.GA8738@redhat.com>	<54079B70.4050200@hurleysoftware.com>	<1409785893.30640.118.camel@pasglop>	<21512.10628.412205.873477@gargle.gargle.HOWL>	<20140904090952.GW17454@tucnak.redhat.com>	<540859EC.5000407@hurleysoftware.com> <20140904175044.4697aee4@alan.etchedpixels.co.uk> <5408C0AB.6050801@hurleysoftware.com>
In-Reply-To: <5408C0AB.6050801@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 12:42 PM, Peter Hurley wrote:
> 
> Or we could give up on the Alpha.
> 

If Alpha is turning into Voyager (kept alive only as a museum piece, but
actively causing problems) then please let's kill it.

	-hpa


