Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab3AUOrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:47:42 -0500
Received: from 8bytes.org ([85.214.48.195]:42286 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965Ab3AUOrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:47:40 -0500
Date: Mon, 21 Jan 2013 15:47:37 +0100
From: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, Udo van den Heuvel <udovdh@xs4all.nl>,
        linux-kernel@vger.kernel.org, Jacob Shin <jacob.shin@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
Message-ID: <20130121144737.GQ25591@8bytes.org>
References: <50FBC7EF.6040207@xs4all.nl>
 <20130120103652.GB16800@pd.tnic>
 <50FBC994.8020409@xs4all.nl>
 <20130120111920.GL25591@8bytes.org>
 <50FBD413.1000406@xs4all.nl>
 <20130120114011.GN25591@8bytes.org>
 <20130120114828.GB16519@pd.tnic>
 <20130120115755.GO25591@8bytes.org>
 <50FD52AB.9080000@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FD52AB.9080000@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jan 21 15:47:38 2013
X-DSPAM-Confidence: 0.9978
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50fd550a22971007520612
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Mon, Jan 21, 2013 at 09:37:31AM -0500, Boris Ostrovsky wrote:
> Are you talking about erratum 746?

The problems seen here are not about PPR failures, so it is not
particularily this erratum, but the workaround looks similar.


	Joerg


