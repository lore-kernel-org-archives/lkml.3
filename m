Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbbAVJeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:34:12 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:64070 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbbAVJeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:34:07 -0500
Message-ID: <1421919245.13638.50.camel@x220>
Subject: KVM: CONFIG_LOCK_DEP and CONFIG_LOCK_DETECTOR?
From: Paul Bolle <pebolle@tiscali.nl>
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org
Date: Thu, 22 Jan 2015 10:34:05 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jan 2015 09:34:05.0731 (UTC) FILETIME=[90A7AF30:01D03626]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mario,

Your commit c64735554c0a ("KVM: arm: Add initial dirty page locking
support") is included in today's linux-next (ie, next-20150122). I
noticed because a script I use to check linux-next spotted a minor
problem with it.

This commit added a comment that mentions CONFIG_LOCK_DEP and
CONFIG_LOCK_DETECTOR. It seems CONFIG_LOCKDEP and CONFIG_LOCKUP_DETECTOR
should be used instead. Is a trivial patch to fix these typos queued
somewhere?

Thanks,


Paul Bolle

