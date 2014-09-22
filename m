Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaIVJjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:39:00 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:39731 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaIVJi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:38:58 -0400
Message-ID: <541FEE2E.7010008@redhat.com>
Date: Mon, 22 Sep 2014 11:38:54 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, gleb@kernel.org, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de
CC: kvm@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 5/9] kvm, mem-hotplug: Reload L1's apic access page
 in vcpu_enter_guest().
References: <1411210071-14727-1-git-send-email-tangchen@cn.fujitsu.com> <1411210071-14727-6-git-send-email-tangchen@cn.fujitsu.com> <541FECE8.3070203@redhat.com>
In-Reply-To: <541FECE8.3070203@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/09/2014 11:33, Paolo Bonzini ha scritto:
> Something's wrong in the way you're generating the patches, because
> you're adding these hunks twice.

Nevermind, that was my mistake.

Paolo
