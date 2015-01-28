Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbbA1UPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:15:52 -0500
Received: from gate.crashing.org ([63.228.1.57]:48005 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079AbbA1UPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:15:49 -0500
Date: Wed, 28 Jan 2015 14:15:33 -0600
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Bogdan Purcareata <bogdan.purcareata@freescale.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] powerpc/mpic: Add DT option to skip readback after EOI
Message-ID: <20150128201533.GA10436@gate.crashing.org>
References: <1422371952-1126-1-git-send-email-bogdan.purcareata@freescale.com> <1422395873.10544.61.camel@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422395873.10544.61.camel@freescale.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 03:57:53PM -0600, Scott Wood wrote:
> At this point, given the previous discussion, does anyone object to
> removing the readback entirely?  Do we have any evidence that reading
> WHOAMI is effective at addressing whatever problem reading EOI made go
> away on the relevant platform?

What platforms were those?  Just test there!

If no one remembers, they can not (any longer) be important platforms ;-)
Just remove the code, and if in twelve months finally someone reports a
failure we will at least know what platform it was.


Segher
