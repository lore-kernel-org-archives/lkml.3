Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab3EPH4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:56:42 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:33230 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab3EPH4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:56:38 -0400
MIME-Version: 1.0
In-Reply-To: <1368666443.2063.22.camel@rzhang1-mobl4>
References: <CANN689GoQm8dGEN6L1xuuc_aZ_65G3N7tBPbEXHjAfebB7xrLw@mail.gmail.com>
	<1368666443.2063.22.camel@rzhang1-mobl4>
Date: Thu, 16 May 2013 00:56:37 -0700
Message-ID: <CANN689EHkK3xzN1bN5tUar=VLQxEanUEvopDH+0qAYkopHJibw@mail.gmail.com>
Subject: Re: ACPI fan driver: uninitialized variable when CONFIG_PM is not set
From: Michel Lespinasse <walken@google.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 6:07 PM, Zhang Rui <rui.zhang@intel.com> wrote:
> Hi, Michel,
>
> thanks for your report.
> please check if the following patch helps or not.
> https://patchwork.kernel.org/patch/2574691/

Yes, this solves the issue.

Is there a chance that this will make it into 3.10 ?

Thanks,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
