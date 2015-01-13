Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbbAMWxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:53:12 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33368 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbbAMWxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:53:11 -0500
Date: Tue, 13 Jan 2015 22:52:59 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Roy Franz <roy.franz@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Geoff Levand <geoff.levand@linaro.org>, Dave Young <dyoung@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [GIT PULL] UEFI updates for arm64
Message-ID: <20150113225259.GA18906@e104818-lin.cambridge.arm.com>
References: <CAKv+Gu-svNbDNhHgFfiT0XPBhMNugWzPZiU4yUzkT9tf0OZ_bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-svNbDNhHgFfiT0XPBhMNugWzPZiU4yUzkT9tf0OZ_bw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 05:51:52PM +0000, Ard Biesheuvel wrote:
> The following changes since commit eaa27f34e91a14cdceed26ed6c6793ec1d186115:
> 
>   linux 3.19-rc4 (2015-01-11 12:44:53 -0800)
> 
> are available in the git repository at:
> 
>   http://git.linaro.org/people/ard.biesheuvel/linux-arm.git tags/for-3.20
> 
> for you to fetch changes up to 9679be103108926cfe9e6fd2f6829cefa77e47b0:
> 
>   arm64/efi: remove idmap manipulations from UEFI code (2015-01-12
> 16:29:32 +0000)
> 
> Some patches touch files under drivers/firmware/efi, these have been
> acked by Matt Fleming, and he is aware that this series is being
> offered for merging through the arm64 tree

Pulled. Thanks.

-- 
Catalin
