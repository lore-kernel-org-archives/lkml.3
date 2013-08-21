Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab3HUEtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 00:49:43 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54349 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3HUEtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 00:49:42 -0400
MIME-Version: 1.0
In-Reply-To: <1377044419-15045-7-git-send-email-josh@joshtriplett.org>
References: <1377044419-15045-1-git-send-email-josh@joshtriplett.org> <1377044419-15045-7-git-send-email-josh@joshtriplett.org>
From: Mike Frysinger <vapier@chromium.org>
Date: Wed, 21 Aug 2013 00:49:20 -0400
X-Google-Sender-Auth: ST_6rLUifMmnP8boFOgDo_QBADk
Message-ID: <CAAbOSckQ3rsbbkn7XDiKNS2bMLWtHDsewmPyoqGDomp5-ve6DQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] turbostat: Factor out common function to open file
 and exit on failure
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Mark Asselstine <mark.asselstine@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 8:20 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> +FILE *fopen_or_die(const char *path, const char *mode)
> +{
> +       FILE *filep = fopen(path, "r");

not a big deal, but would be nice to add the "e" flag
-mike
