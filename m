Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab3CVLEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:04:36 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:51719 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab3CVLEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:04:34 -0400
MIME-Version: 1.0
In-Reply-To: <1363809337-29718-1-git-send-email-riel@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
Date: Fri, 22 Mar 2013 18:04:33 +0700
Message-ID: <CA+i8gKKK_VxZtyyp1tqHnztd4++XyNXwbEEr-A29-J23PyuCfQ@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Rik van Riel <riel@surriel.com>
Cc: torvalds@linux-foundation.org, davidlohr.bueso@hp.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

On Thu, Mar 21, 2013 at 2:55 AM, Rik van Riel <riel@surriel.com> wrote:
> This series makes the sysv semaphore code more scalable,
> by reducing the time the semaphore lock is held, and making
> the locking more scalable for semaphore arrays with multiple
> semaphores.

I was trying your patchset and my machine died while building a
package. I could reproduce the bug the (only) two times I tried.
There's a poor quality picture here: http://i.imgur.com/MuYuyQC.jpg

Thanks.
-- Emmanuel
