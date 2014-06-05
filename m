Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaFENMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:12:33 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45498 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaFENMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:12:32 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVMnM6w5ZLX=S8fJHeVoEqxH2JG3Wg=GPMeoVnOpAjsvAA@mail.gmail.com>
References: <CACVXFVMnM6w5ZLX=S8fJHeVoEqxH2JG3Wg=GPMeoVnOpAjsvAA@mail.gmail.com>
Date: Thu, 5 Jun 2014 06:12:31 -0700
Message-ID: <CAPcyv4icNZU9s7zLYYcrFrNA_9qk4W1je42KKG+ETWqdoQu_kg@mail.gmail.com>
Subject: Re: [Regression] commit 8a4aeec8d(libata/ahci: accommodate tag
 ordered controllers)
From: Dan Williams <dan.j.williams@intel.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 1:53 AM, Ming Lei <ming.lei@canonical.com> wrote:
> Hi Dan and Tejun,
>
> Looks the commit 8a4aeec8d(libata/ahci: accommodate tag ordered
> controllers) causes below sata failure[1] on APM AHCI controller.
>
> And the error does disappear after reverting the commit.

Can you give some more details about the workload and the disk?  What
is the APM AHCI?
