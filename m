Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbbAVJTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:19:49 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:59847 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbbAVJTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:19:45 -0500
Message-ID: <1421918381.13638.43.camel@x220>
Subject: KVM: HAVE_KVM_ARCH_DIRTY_LOG_PROTECT?
From: Paul Bolle <pebolle@tiscali.nl>
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 22 Jan 2015 10:19:41 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jan 2015 09:19:42.0038 (UTC) FILETIME=[8DDA9760:01D03624]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mario,

Your commit ba0513b5b8ff ("KVM: Add generic support for dirty page
logging") is included in today's linux-next (ie, next-20150122). I
noticed because a script I use to check linux-next spotted a problem
with it.

That commit added a Kconfig symbol HAVE_KVM_ARCH_DIRTY_LOG_PROTECT. But
nothing in linux-next uses that symbol. Why was it added?

Thanks,


Paul Bolle

