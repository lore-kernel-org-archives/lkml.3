Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbbAHBsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:48:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:40612 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbbAHBsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:48:21 -0500
Date: Wed, 7 Jan 2015 18:49:08 -0600
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Purcareata Bogdan <b43198@freescale.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] PPC: MPIC: necessary readback after EOI?
Message-ID: <20150108004908.GA11770@gate.crashing.org>
References: <54AA9C4D.3000001@freescale.com> <1420641610.5830.29.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420641610.5830.29.camel@kernel.crashing.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 03:40:10PM +0100, Benjamin Herrenschmidt wrote:
> One way to work around the performance loss for you would be to add some
> DT property to indicate to the guest that the read isn't necessary.

Or KVM could use a virtual interrupt controller better suited to its
needs.


Segher
