Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab3LEPxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:53:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756764Ab3LEPxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:53:12 -0500
Message-ID: <1386258761.1861.137.camel@deneb.redhat.com>
Subject: Re: [PATCH 3/3] arm64: add EFI runtime services
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>
Date: Thu, 05 Dec 2013 10:52:41 -0500
In-Reply-To: <20131205152510.GB974@darko.cambridge.arm.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
	 <1385762712-17043-4-git-send-email-msalter@redhat.com>
	 <20131205152510.GB974@darko.cambridge.arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-05 at 15:25 +0000, Catalin Marinas wrote:
> I lost track of the early_ioremap status for arm/arm64? Was there more
> progress since October (I think)?

See the two patch series:

 https://lkml.org/lkml/2013/11/25/474

and

 https://lkml.org/lkml/2013/11/27/621

The latter early_ioremap depends on the first although there are no
arm64 bits in the first. All of the arm64 early_ioremap stuff is in
the latter.

--Mark


