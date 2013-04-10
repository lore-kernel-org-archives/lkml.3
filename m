Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab3DJKFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:05:51 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:42361 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3DJKFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:05:49 -0400
MIME-Version: 1.0
From: Santosh Y <santoshsy@gmail.com>
Date: Wed, 10 Apr 2013 19:05:28 +0900
Message-ID: <CALMYJDtnJQXZ2jjCteDaTYs4de0941HEyfmdwH0KrC-bkvMttg@mail.gmail.com>
Subject: Re: scsi: ufs: add support for query requests
To: draviv@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, vinayak holikatti <vinholikatti@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> This can be done inside the following if condition i.e. if
> (hba->query.descriptor != NULL).
> and change the condition to if (!hba->query.descriptor).
>

I meant to write  if (hba->query.descriptor)...:-)
--
~Santosh
