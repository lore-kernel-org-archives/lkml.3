Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3JaNHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 09:07:10 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48198 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3JaNHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 09:07:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXp+9XKbs8ccJVt08icax6SOWioDfL5s+H1SWGi9cTAiw@mail.gmail.com>
References: <5270DBFC.3050705@cn.fujitsu.com> <CAE9FiQXp+9XKbs8ccJVt08icax6SOWioDfL5s+H1SWGi9cTAiw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 31 Oct 2013 07:06:46 -0600
Message-ID: <CAErSpo6GURsmnjd8THvi4V1PruQChKLTOyCUAaiO+p4JDiwz=g@mail.gmail.com>
Subject: Re: [PATCH] pci: fix invalid list entry warning for double pci device
 removing via sysfs
To: Yinghai Lu <yinghai@kernel.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 12:45 AM, Yinghai Lu <yinghai@kernel.org> wrote:

> I have updated version, please check if attached patches fix the problem.
>
> virtfn_release.patch
> fix_cx3_hotplug_2.patch
> fix_racing_removing_6_1.patch
> fix_racing_removing_6_2.patch
> fix_racing_removing_6_3.patch

Ignored because it's a hassle for me to deal with attachments.  They
don't show up in patchwork, it's hard for reviewers to comment on
them, and I have to manually download the attachments and keep track
of what order they need to go in.

Bjorn
