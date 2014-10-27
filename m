Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaJ0UMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:12:41 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:47576 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaJ0UMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:12:40 -0400
MIME-Version: 1.0
In-Reply-To: <1414433284-31719-18-git-send-email-a.motakis@virtualopensystems.com>
References: <1414433284-31719-1-git-send-email-a.motakis@virtualopensystems.com>
 <1414433284-31719-18-git-send-email-a.motakis@virtualopensystems.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 27 Oct 2014 14:12:17 -0600
Message-ID: <CAErSpo7AD4ZJa=N5TqbSfdHjH2miL27Fvc5wsjqo_Q6sk2-cDg@mail.gmail.com>
Subject: Re: [PATCH v9 17/19] vfio: virqfd: add vfio_ prefix to virqfd_enable
 and virqfd_disable
To: Antonios Motakis <a.motakis@virtualopensystems.com>
Cc: kvmarm@lists.cs.columbia.edu,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Will Deacon <will.deacon@arm.com>, tech@virtualopensystems.com,
        Christoffer Dall <christoffer.dall@linaro.org>, eric.auger@linaro.org,
        kim.phillips@freescale.com, Marc Zyngier <marc.zyngier@arm.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 12:08 PM, Antonios Motakis
<a.motakis@virtualopensystems.com> wrote:
> The virqfd_enable and virqfd_disable functions are now global. Add the
> vfio_ prefix to those functions.

Wouldn't it be better to change the name *before* making them global?

Bjorn
