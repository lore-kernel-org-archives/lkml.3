Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab3CARsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:48:55 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60460 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3CARsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:48:53 -0500
Date: Fri, 1 Mar 2013 17:48:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Shewmaker <agshew@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] mm: tuning hardcoded reserved memory
Message-ID: <20130301174852.5d568191@www.etchedpixels.co.uk>
In-Reply-To: <20130228034803.GB3829@localhost.localdomain>
References: <20130227205629.GA8429@localhost.localdomain>
	<20130228141200.3fe7f459.akpm@linux-foundation.org>
	<20130228034803.GB3829@localhost.localdomain>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 3% reserve was added to the original code *because* users kept hitting
problems where they couldn't recover. 

I suspect the tunable should nowdays be something related to min(3%,
someconstant), at the time we did the 3% I think 1GB was an "enterprise
system" ;)

Alan
