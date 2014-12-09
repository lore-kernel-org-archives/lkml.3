Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaLIUXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:23:10 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:38048 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbaLIUXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:23:08 -0500
MIME-Version: 1.0
In-Reply-To: <5486BBB1.3040405@linaro.org>
References: <1418079900-4640-1-git-send-email-mcgrof@do-not-panic.com>
 <1418079900-4640-3-git-send-email-mcgrof@do-not-panic.com> <5486BBB1.3040405@linaro.org>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 9 Dec 2014 12:22:45 -0800
X-Google-Sender-Auth: Qm5wyVhoJHtgGr9v8t94HIEIzRU
Message-ID: <CAB=NE6V+kLaZePAzHim0VxGsd8ew6dS7kN=H=awwz1dpHy5VJw@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH v3 2/2] x86, arm64, platform, xen, kconfig:
 add xen defconfig helper
To: Julien Grall <julien.grall@linaro.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, josh@joshtriplett.org, sam@ravnborg.org,
        Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <Ian.Campbell@citrix.com>, kvm@vger.kernel.org,
        x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mtosatti@redhat.com, Pekka Enberg <penberg@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org,
        Borislav Petkov <bp@suse.de>, David Vrabel <david.vrabel@citrix.com>,
        Benjamin Poirier <bpoirier@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 1:06 AM, Julien Grall <julien.grall@linaro.org> wrote:
> Hello Luis,
>
> On 08/12/2014 23:05, Luis R. Rodriguez wrote:
>>
>> diff --git a/kernel/configs/xen.config b/kernel/configs/xen.config
>> new file mode 100644
>> index 0000000..0d0eb6d
>> --- /dev/null
>> +++ b/kernel/configs/xen.config
>> +CONFIG_XEN_MCE_LOG=y
>
>
> MCE is x86 specific.

That's what I thought too but its available for arm64, so should we
fix that Kconfig to depend on x86?

>> +CONFIG_XEN_HAVE_PVMMU=y
>
>
> We don't have PVMMU support on ARM. Shouldn't you move this config in
> architecture specific code?

If you are sure then yes.

 Luis
