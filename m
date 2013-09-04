Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab3IDSlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:41:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44387 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab3IDSlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:41:01 -0400
Message-ID: <52277EBA.6030105@wwwdotorg.org>
Date: Wed, 04 Sep 2013 12:40:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>
CC: thierry.reding@gmail.com, tbergstrom@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] host1x: hdmi: Detect whether display is connected
 with HDMI or DVI
References: <1377704922-2824-1-git-send-email-mperttunen@nvidia.com> <1377704922-2824-3-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1377704922-2824-3-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 09:48 AM, Mikko Perttunen wrote:
> Use EDID data to determine whether the display supports HDMI or just DVI.
> This used to be hardcoded to be HDMI, which broke support for DVI displays
> that couldn't understand the interspersed audio/other data.
> 
> If the EDID data isn't available, default to DVI, which should be a safer
> choice.

This seems like a bug-fix that might even be worth CC: stable?
