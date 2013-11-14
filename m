Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3KNSvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:51:05 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48315 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3KNSuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:50:55 -0500
MIME-Version: 1.0
In-Reply-To: <1384454534-27807-1-git-send-email-geyslan@gmail.com>
References: <1384454534-27807-1-git-send-email-geyslan@gmail.com>
Date: Thu, 14 Nov 2013 20:50:54 +0200
X-Google-Sender-Auth: VbFaIWaZcACqjllzJzQEzhqBMmo
Message-ID: <CAOJsxLFgB8v1+kcYJEJTDORkyKVdQ161aLyEmUXJwzSAHT6Wsw@mail.gmail.com>
Subject: Re: [PATCH] ecryptfs: Fix explicit null dereference
From: Pekka Enberg <penberg@kernel.org>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: Tyler Hicks <tyhicks@canonical.com>,
        "open list:ECRYPT FILE SYSTEM" <ecryptfs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 8:42 PM, Geyslan G. Bem <geyslan@gmail.com> wrote:
> If the condition 'ecryptfs_file_to_private(file)' takes false branch
> lower_file is dereferenced when NULL.
>
> Caught by Coverity: CIDs 1128834 and 1128833.
>
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
