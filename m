Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3LBX40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:56:26 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57071 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab3LBX4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:56:24 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA6Mh=tRM5h=TCbg5yjkkFUg2OncJmHBdtBhG7jqf377rg@mail.gmail.com>
References: <CA+5PVA6Mh=tRM5h=TCbg5yjkkFUg2OncJmHBdtBhG7jqf377rg@mail.gmail.com>
Date: Mon, 2 Dec 2013 18:56:24 -0500
X-Google-Sender-Auth: 4dFPzIn2V9ctRvNkcOJI0TeKQDQ
Message-ID: <CA+5PVA4pXtXHWzeSnx7d9eGEiOQ-jtL2RtBEyqxmz2DemT--jw@mail.gmail.com>
Subject: Re: Nov. Fedora Kernel Patch Report
From: Josh Boyer <jwboyer@fedoraproject.org>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kernel Fedora <kernel@lists.fedoraproject.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 2:40 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> A couple days late due to the holidays.  Here are the patches we
> currently have on top of 3.12.2:

Forgot the upstream commit sha1s where relevant.  Sigh.  That's what I
get for rushing.

> md-test-mddev-flags-more-safely-in-md_check_recovery.patch (rhbz 1033971)
> - In 3.13, should already be CC'd to stable

commit 142d44c310819e1965ca70b4d55d7679f5797e25

> inet-prevent-leakage-of-uninitialized-memory-to-user.patch
> inet-fix-addr_len-msg_namelen-assignment-in-recv_error-and-rxpmtu-functions.patch
> (rhbz 1035875)
> - Should be heading to 3.13.  Fixes CVE-2013-6405

Commits bceaa90240b6 and 85fbaa75037d

> usbnet-fix-status-interrupt-urb-handling.patch (rhbz 998342)
> - In 3.13

commit 52f48d0d9aaa621ffa5e08d79da99a3f8c93b848

> via-velocity-fix-netif_receive_skb-use-in-irq-disable.patch (rhbz 1022733)
> - Submitted for 3.13 and CC'd to 3.12 stable

commit bc9627e7e918a85e906c1a3f6d01d9b8ef911a96

> drm-radeon-24hz-audio-fixes.patch (rhbz 1010679)
> - Should be in 3.13

Commits 908171aa738b5bbcc6241cec46f73fcd57dd00d4 and
05e4776357fe7217e531cbaaa163e24f688d10ce

> alx-Reset-phy-speed-after-resume.patch (rhbz 1011362)
> - In 3.13

commit b54629e226d196e802abdd30c5e34f2a47cddcf2

> ip6_output-fragment-outgoing-reassembled-skb-properl.patch
> netfilter-push-reasm-skb-through-instead-of-original.patch (rhbz 1015905)
> - 3.13 and CC'd to stable

commit 9037c3579a277f3a23ba476664629fda8c35f7c4 and
6aafeef03b9d9ecf255f3a80ed85ee070260e1ae

> ipv6-fix-headroom-calculation-in-udp6_ufo_fragment.patch (rhbz 1030015)
> - 3.13.  Fixes CVE-2013-4563

commit 0e033e04c2678dbbe74a46b23fffb7bb918c288e

> Input-evdev-fall-back-to-vmalloc-for-client-event-buffer.patch
> - Fixes high order allocations.  In 3.13

commit 92eb77d0ffbaa71b501a0a8dabf09a351bf4267f

> vfio-iommu-Fixed-interaction-of-VFIO_IOMMU_MAP_DMA.patch (rhbz 998732)
> - In 3.13

commit f9423606ade08653dd8a43334f0a7fb45504c5cc

> iommu-Remove-stack-trace-from-broken-irq-remapping-warning.patch (rhbz 982153)
> - In 3.13

commit 05104a4e8713b27291c7bb49c1e7e68b4e243571

> rt2800-add-support-for-rf3070.patch (rhbz 974072)
> - In 3.13

commit 3b9b74baa1af2952d719735b4a4a34706a593948

> elevator-Fix-a-race-in-elevator-switching-and-md.patch
> elevator-acquire-q-sysfs_lock-in-elevator_change.patch (rhbz 902012)
> - In 3.13

commit eb1c160b22655fd4ec44be732d6594fd1b1e44f4 and
7c8a3679e3d8e9d92d58f282161760a0e247df97

> ntp-Make-periodic-RTC-update-more-reliable.patch (rhbz 985522)
> - In 3.13

commit a97ad0c4b447a132a322cedc3a5f7fa4cab4b304

josh
