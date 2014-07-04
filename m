Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbaGDFoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 01:44:16 -0400
Received: from david.siemens.de ([192.35.17.14]:37768 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbaGDFoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 01:44:14 -0400
Message-ID: <53B63F2B.1050503@siemens.com>
Date: Fri, 04 Jul 2014 07:44:11 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Hu Yaohui <loki2441@gmail.com>, kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Le Tan <tamlokveer@gmail.com>
Subject: Re: direct device assignment in nested VM
References: <CAHqbYQsN-9zMrsZ6aBG-iJ=vJ58y1s_tz5kX63Jo+kf+Nd2q1Q@mail.gmail.com>
In-Reply-To: <CAHqbYQsN-9zMrsZ6aBG-iJ=vJ58y1s_tz5kX63Jo+kf+Nd2q1Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-04 05:27, Hu Yaohui wrote:
> Hi All,
> Is direct device assignment in nested VM supported in the latest KVM
> mainline now?

Le Tan is currently working on emulated device assignment (VT-d
emulation in QEMU). This is the necessary first step and could later be
extended to enable assignment of physical devices to nested guests with
support of the host IOMMU (out of scope for Le's project, though).

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
