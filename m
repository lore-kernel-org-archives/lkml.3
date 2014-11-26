Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaKZXnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:43:05 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:44115 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaKZXnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:43:03 -0500
MIME-Version: 1.0
In-Reply-To: <1417032936-11809-1-git-send-email-jilaiw@codeaurora.org>
References: <1417032936-11809-1-git-send-email-jilaiw@codeaurora.org>
Date: Wed, 26 Nov 2014 15:43:00 -0800
Message-ID: <CAJAp7OhO7dYmVTY=a+4yC9JMnwtcJrA2tmGH2dpKY8faWDovHA@mail.gmail.com>
Subject: Re: [PATCH 1/4] drm/msm/hdmi: use HPD interrupt to track connector
 status change
From: Bjorn Andersson <bjorn@kryo.se>
To: Jilai Wang <jilaiw@codeaurora.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 12:15 PM, Jilai Wang <jilaiw@codeaurora.org> wrote:
> HPD interrupt can be tracked for each connector, so don't need
> to poll the connector status for state change.
>
> Change-Id: I2c062838af5922d32ce87a50676a45dcaedb44f2

Please remove the Change-Id when sending patches to the kernel.

Regards,
Bjorn
