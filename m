Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab3EVRzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:55:43 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:53420 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3EVRzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:55:39 -0400
Message-ID: <519D0697.5050505@kernel.org>
Date: Wed, 22 May 2013 20:55:35 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
        Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        bp@suse.de, fengguang.wu@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH -v2] x86: Add a kvm config file
References: <20130503142900.GA3433@pd.tnic> <5183CFAC.8020005@infradead.org> <20130503150818.GC3433@pd.tnic> <5183D357.8000204@suse.cz> <20130503153134.GD3433@pd.tnic> <alpine.DEB.2.02.1305030952140.30317@chino.kir.corp.google.com> <aea679e3-048a-4f28-b164-73191095a995@email.android.com> <alpine.DEB.2.02.1305031016290.32047@chino.kir.corp.google.com> <51840B70.2000205@linux.intel.com> <20130503233610.GE3433@pd.tnic> <20130522144638.GB15085@pd.tnic>
In-Reply-To: <20130522144638.GB15085@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/13 5:46 PM, Borislav Petkov wrote:
> Add an config file snippet which enables additional options useful for
> running the kernel in a kvm guest. When you execute 'make kvmconfig' it
> merges those options with an already existing user config before you
> build the kernel.
>
> Based on an patch from the external lkvm tree.
>
> Signed-off-by: Borislav Petkov <bp@suse.de>

Acked-by: Pekka Enberg <penberg@kernel.org>

