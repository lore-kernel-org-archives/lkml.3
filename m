Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaBYJYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:24:08 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:47788 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaBYJYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:24:01 -0500
MIME-Version: 1.0
In-Reply-To: <1392987687-15367-12-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
	<1392987687-15367-12-git-send-email-luis.henriques@canonical.com>
Date: Tue, 25 Feb 2014 10:24:00 +0100
Message-ID: <CACRpkdbHjxsggj8gY=+dzgFXp7KFqZhfebkGZVJZpvErTocPGg@mail.gmail.com>
Subject: Re: [PATCH 3.5 11/60] pinctrl: do not init debugfs entries for
 unimplemented functionalities
From: Linus Walleij <linus.walleij@linaro.org>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, kernel-team@lists.ubuntu.com,
        Florian Vaussard <florian.vaussard@epfl.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 2:00 PM, Luis Henriques
<luis.henriques@canonical.com> wrote:

> 3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

This was NACKed as stable patch by Greg so drop it if not too late.

Yours,
Linus Walleij
