Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab3DCBUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:20:36 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50669 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759159Ab3DCBUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:20:35 -0400
MIME-Version: 1.0
In-Reply-To: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
Date: Wed, 3 Apr 2013 10:15:26 +0900
Message-ID: <CAKYAXd8P-G6qV-X8HxypdbQtCydyvy6MFnRWpGgsONbJ2LGoow@mail.gmail.com>
Subject: Re: [PATCH 1/9] f2fs: do not use duplicate names in a macro
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/1, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> A macro should not use duplicate parameter names.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Looks reasonable to me ~
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks.
> ---
