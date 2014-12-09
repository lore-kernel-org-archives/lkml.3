Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbaLIJHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:07:05 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56280 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaLIJHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:07:01 -0500
Message-ID: <5486BBB1.3040405@linaro.org>
Date: Tue, 09 Dec 2014 09:06:57 +0000
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, hpa@zytor.com,
        josh@joshtriplett.org, sam@ravnborg.org
CC: Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <Ian.Campbell@citrix.com>, kvm@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        Pekka Enberg <penberg@kernel.org>, fengguang.wu@intel.com,
        levinsasha928@gmail.com, David Rientjes <rientjes@google.com>,
        xen-devel@lists.xenproject.org, Borislav Petkov <bp@suse.de>,
        David Vrabel <david.vrabel@citrix.com>, bpoirier@suse.de
Subject: Re: [Xen-devel] [PATCH v3 2/2] x86, arm64, platform, xen, kconfig:
 add xen defconfig helper
References: <1418079900-4640-1-git-send-email-mcgrof@do-not-panic.com> <1418079900-4640-3-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1418079900-4640-3-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Luis,

On 08/12/2014 23:05, Luis R. Rodriguez wrote:
> diff --git a/kernel/configs/xen.config b/kernel/configs/xen.config
> new file mode 100644
> index 0000000..0d0eb6d
> --- /dev/null
> +++ b/kernel/configs/xen.config
> +CONFIG_XEN_MCE_LOG=y

MCE is x86 specific.

> +CONFIG_XEN_HAVE_PVMMU=y

We don't have PVMMU support on ARM. Shouldn't you move this config in 
architecture specific code?

Regards

-- 
Julien Grall
