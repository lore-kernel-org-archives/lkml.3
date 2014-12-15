Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751030AbaLORRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:17:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:40786 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaLORRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:17:14 -0500
Date: Mon, 15 Dec 2014 18:17:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Kepplinger <martink@posteo.de>
Cc: mingo@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org
Subject: Re: add sign-extend functions for 8 and 16 bit values
Message-ID: <20141215171702.GR3337@twins.programming.kicks-ass.net>
References: <1418660317-21750-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418660317-21750-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 05:18:31PM +0100, Martin Kepplinger wrote:
> This adds sign_extend8() and sign_extend16() for the quite many cases
> where this is needed, like sign_extend32().

We're still missing sign_extend64() after this.

