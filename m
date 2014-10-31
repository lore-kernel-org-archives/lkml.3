Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbaJaUDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:03:11 -0400
Received: from one.firstfloor.org ([193.170.194.197]:57894 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaJaUDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:03:10 -0400
Date: Fri, 31 Oct 2014 21:03:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: kan.liang@intel.com
Cc: acme@kernel.org, jolsa@kernel.org, linux-kernel@vger.kernel.org,
        andi@firstfloor.org
Subject: Re: [PATCH 1/1] perf tools: perf diff for different binaries
Message-ID: <20141031200308.GZ12538@two.firstfloor.org>
References: <1414757172-20064-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414757172-20064-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> If I run old perf diff with --sort dso,symbol, we cannot get any useful
> information for the user space binary. Furthermore, it failed to compare
> the kernel function. E.g. native_write_msr_safe.
> 
> perf diff -s dso,symbol --compute ratio v1_1_6perf.data v2_1_7perf.data

The new option needs to be documented in the manpage

(with a paragraph explaining that it allows comparison
between different versions of the binary)

-Andi
