Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaBNE2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:28:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48107 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbaBNE2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:28:19 -0500
Message-ID: <52FD9B5A.4020905@zytor.com>
Date: Thu, 13 Feb 2014 20:28:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
CC: linux-kbuild@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 14/17] Kbuild, lto: Add Link Time Optimization support
References: <1391846481-31491-1-git-send-email-ak@linux.intel.com> <1391846481-31491-14-git-send-email-ak@linux.intel.com>
In-Reply-To: <1391846481-31491-14-git-send-email-ak@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am about to commit the patches before this except 02/17 and 12/17 to
tip:x86/asmlinkage; however, I figure we need a new 02/17 before
committing the actual LTO patches to avoid build breakage.

	-hpa

