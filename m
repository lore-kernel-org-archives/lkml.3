Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3BORyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:54:53 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:40891 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab3BORyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:54:52 -0500
MIME-Version: 1.0
In-Reply-To: <20121127221608.11315.49374.stgit@djiang5-linux.ch.intel.com>
References: <20121127221608.11315.49374.stgit@djiang5-linux.ch.intel.com>
Date: Fri, 15 Feb 2013 09:54:50 -0800
X-Google-Sender-Auth: c_D01uyF9F-NEKatQ4pNQ5Xw2QA
Message-ID: <CAA9_cmc6H0in8SEv9=hY3x6pRoeQVHxKpRSp2v52+3mhPHsSrg@mail.gmail.com>
Subject: Re: [PATCH v2] ioat: remove chanerr mask setting for IOAT v3.x
From: Dan Williams <djbw@fb.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org, jon.mason@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 2:16 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> The existing code set a value in the PCI_CHANERRMSK_INT register
> for a workaround to address a pre-silicon bug on the Intel 5520 IO hub that
> has been fixed when the hardware was released. There is no need for this
> code.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Acked-by: Dan Williams <djbw@fb.com>
