Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964952Ab3DHP3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:29:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:48886 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936279Ab3DHP3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:29:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="291781628"
Date: Mon, 8 Apr 2013 17:29:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Subject: Re: [PATCH] mfd: trivially fix build warning in sta2x11-mfd
Message-ID: <20130408152913.GW24058@zurbaran>
References: <20130222093959.GA6549@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222093959.GA6549@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alessandro,

On Fri, Feb 22, 2013 at 10:39:59AM +0100, Alessandro Rubini wrote:
> This driver cannot be a module, so "remove" is never called.  The
> mishap is mine, and back then there was no warning due to __devexit().
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> ---
>  drivers/mfd/sta2x11-mfd.c |   11 -----------
>  1 files changed, 0 insertions(+), 11 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
