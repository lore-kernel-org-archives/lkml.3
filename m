Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaLBRvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:51:00 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:48110 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbaLBRu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:50:58 -0500
MIME-Version: 1.0
In-Reply-To: <1417467084-4579-1-git-send-email-jilaiw@codeaurora.org>
References: <1417467084-4579-1-git-send-email-jilaiw@codeaurora.org>
Date: Tue, 2 Dec 2014 12:50:57 -0500
Message-ID: <CAF6AEGtsJMxkpJSLqh2hor66_=_EB0seKiNBrMqMKCYetQKCRw@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/msm/hdmi: add register description for HDMI HDCP support
From: Rob Clark <robdclark@gmail.com>
To: Jilai Wang <jilaiw@codeaurora.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 3:51 PM, Jilai Wang <jilaiw@codeaurora.org> wrote:
> Add HDCP related register description.
>
> Signed-off-by: Jiali Wang <jilaiw@codeaurora.org>
> ---
>  drivers/gpu/drm/msm/hdmi/hdmi.xml.h | 76 +++++++++++++++++++++++++++++--------
>  1 file changed, 60 insertions(+), 16 deletions(-)
>

This one I'll just drop and regenerate the headers myself, now that
I've pushed your corresponding rnndb patch.  It's the easier way to
resolve merge conflicts w/ the generated headers ;-)

BR,
-R
