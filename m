Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab3JJRhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:37:52 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59930 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3JJRhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:37:50 -0400
MIME-Version: 1.0
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 10 Oct 2013 11:37:29 -0600
Message-ID: <CAErSpo5+xbgTfBrQdP36PRfOFpQcdeSgOEBFFDCfZoqoAsch5g@mail.gmail.com>
Subject: Re: [ 3.8.y.z extended stable ] Linux 3.8.13.11 stable review
To: Kamal Mostafa <kamal@canonical.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        kernel-team@lists.ubuntu.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 9:40 AM, Kamal Mostafa <kamal@canonical.com> wrote:
> This is the start of the review cycle for the Linux 3.8.13.11 stable kernel.

Would anybody be interested in adding some sort of "stable" tag to the
subject lines of stable backport patches, e.g.,  instead of:

  [PATCH 001/104] htb: fix sign extension bug

something like:

  [STABLE 3.8.13.11 001/104] htb: fix sign extension bug

I don't mind having the stable patches on LKML, but it would be nice
if it were easier to distinguish stable backports from new patches.  I
know the patches are nicely threaded behind this message, but some
readers don't really pay attention to that.

Bjorn
