Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab3KMPNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:13:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757601Ab3KMPM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:12:58 -0500
Message-ID: <528396F4.1060005@suse.cz>
Date: Wed, 13 Nov 2013 16:12:52 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Mario <jmario@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 2/2] kallsyms: Revert back to 128 max symbol length
References: <1384177236-8371-1-git-send-email-mmarek@suse.cz> <1384177236-8371-2-git-send-email-mmarek@suse.cz> <20131111141715.GM1962@tassilo.jf.intel.com> <5282A3E2.30103@redhat.com>
In-Reply-To: <5282A3E2.30103@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.11.2013 22:55, Joe Mario wrote:
>   Given there are 5 other locations in the code that need to be changed
>   from [128] to [KSYM_NAME_LEN], and that we still haven't found Fengguang's
>   problem yet, I'd be in favor of letting Michal's revert patch 2/2 go forward.

It's in kbuild.git#kbuild now. If Bjorn merges the PCI patch, then the
issue with LTO will be resolved even without increasing the symbol length.

Michal
