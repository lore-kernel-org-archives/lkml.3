Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab3JOQCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:02:39 -0400
Received: from one.firstfloor.org ([193.170.194.197]:44484 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759170Ab3JOQCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:02:38 -0400
Date: Tue, 15 Oct 2013 18:02:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: =?iso-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
        Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple
 alu's
Message-ID: <20131015160236.GG2592@two.firstfloor.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <87siw4xy9i.fsf@tassilo.jf.intel.com>
 <20131014202528.GG26880@hmsreliant.think-freely.org>
 <20131015091251.2345b918@b012350-ux>
 <20131015133336.GF2592@two.firstfloor.org>
 <20131015155615.738f03d5@b012350-ux>
 <1381845985.2045.40.camel@edumazet-glaptop.roam.corp.google.com>
 <20131015161528.08c19e92@b012350-ux>
 <1381847168.2045.45.camel@edumazet-glaptop.roam.corp.google.com>
 <1381848748.2045.50.camel@edumazet-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381848748.2045.50.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I get the csum_partial() if disabling prequeue.

At least in the ipoib case i would consider that a misconfiguration.

"don't do this if it hurts"

There may be more such problems.

-Andi
