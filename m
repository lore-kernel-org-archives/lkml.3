Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaKDLij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:38:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43757 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaKDLif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:38:35 -0500
Date: Tue, 4 Nov 2014 12:38:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "aravind.gopalakrishnan@amd.com" <aravind.gopalakrishnan@amd.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, mce: support memory error recovery for both
 UCNA and Deferred error in machine_check_poll
Message-ID: <20141104113828.GA9570@pd.tnic>
References: <1414371382-15491-1-git-send-email-slaoub@gmail.com>
 <1414371382-15491-3-git-send-email-slaoub@gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F32917841@ORSMSX114.amr.corp.intel.com>
 <1414548964.20336.17.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1414548964.20336.17.camel@debian>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 10:16:04AM +0800, Chen Yucong wrote:
> +	/*
> +	 * mce_severity is specific to machine check exception, and it will
> +	 * check MCIP/EIPV/RIPV bits. In order to get pass the check, we need
> +	 * to set MCIP and RIPV.
> +	 */

No, no more hacks please! Less hacks and cleaner code instead.

You need to integrate it properly in the current solution, or, if the
current solution doesn't provide a proper way of integrating UCNA
errors, then you need to extend it and improve it to do so.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
