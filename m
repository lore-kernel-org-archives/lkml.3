Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab3BVKgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:36:49 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:36311 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534Ab3BVKgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:36:46 -0500
X-Greylist: delayed 669 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2013 05:36:45 EST
Date: Fri, 22 Feb 2013 11:25:22 +0100
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: trivially fix build warning in sta2x11-mfd
Message-ID: <20130222102522.GA13669@mail.gnudd.com>
References: <20130222093959.GA6549@mail.gnudd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130222093959.GA6549@mail.gnudd.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M >ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 10:39:59AM +0100, Alessandro Rubini wrote:
> This driver cannot be a module, so "remove" is never called.  The
> mishap is mine, and back then there was no warning due to __devexit().
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>


Acked-by: Davide Ciminaghi <ciminaghi@gnudd.com>

Thanks
Davide
