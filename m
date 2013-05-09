Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab3EIWqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:46:38 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:39377 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab3EIWqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:46:37 -0400
Message-ID: <518C26FD.4000406@gmail.com>
Date: Thu, 09 May 2013 15:45:17 -0700
From: Matthieu Bec <mdcb808@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Add ability to keep track of callers of symbol_(get|put) ? (take
 2)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I came into the situation previously reported as "[RFC PATCH 1/3] Add 
ability to keep track of callers of symbol_(get|put)"

The thread is here - https://lkml.org/lkml/2007/3/9/519

A patch was submitted back then. Maybe it drop off the radar?

On 3.8.11 kernel, I find that

- for symbol_get, the 'holder' field of the resolved symbol's module 
does not update. mild annoyance IMHO

- for symbol_put, when ref. count reaches 0, there is no 'rmmod' 
equivalent so it just stays there in memory. That somewhat seemed less 
deliberate?

Regards
