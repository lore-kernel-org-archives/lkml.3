Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab3GKApi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:45:38 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:50067 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3GKApg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:45:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAKwO_5EhHaJs23+Y6EiwrXaBUPj=MBGHuQ+E2nUyMYphBBGpJQ@mail.gmail.com>
References: <1373497956-8770-1-git-send-email-taysom@chromium.org>
	<20130710235636.GA2879@redhat.com>
	<CAKwO_5EhHaJs23+Y6EiwrXaBUPj=MBGHuQ+E2nUyMYphBBGpJQ@mail.gmail.com>
Date: Wed, 10 Jul 2013 17:45:35 -0700
Message-ID: <CAKwO_5EpX40pAWb8ReY6YgOhy6CYKUkSYotx_Fe9e2jjoXwuNg@mail.gmail.com>
Subject: Re: [PATCH] fs: sync: fixed performance regression
From: Paul Taysom <taysom@google.com>
To: Dave Jones <davej@redhat.com>, Paul Taysom <taysom@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jack@suse.cz, sonnyrao@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Third time is the charm crbug.com/240411
