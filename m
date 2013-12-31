Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab3LaT0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 14:26:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50868 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab3LaT0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:26:12 -0500
Message-ID: <52C31A51.5000102@infradead.org>
Date: Tue, 31 Dec 2013 11:26:09 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org
CC: x86@kernel.org
Subject: Re: [PATCH 09/12] x86 Kconfig: create mtrr menu
References: <20131230184046.F5E42919@viggo.jf.intel.com> <20131230184058.0A59E033@viggo.jf.intel.com>
In-Reply-To: <20131230184058.0A59E033@viggo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/13 10:40, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This removes another 4 lines from the default x86 menu.  Note
> that I slightly changed the MTRR prompt text since PAT is
> hidden under here.  This makes PAT easier to find since it
> "depends on MTRR" anyway.

I would have put MTRR/PAT in the new Processor Options and Features
menu.

How do you decide what goes where?


-- 
~Randy
