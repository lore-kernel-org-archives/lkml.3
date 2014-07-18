Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbaGRD6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 23:58:19 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:47694 "HELO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753959AbaGRD6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 23:58:17 -0400
MIME-Version: 1.0
From: Derrick Pallas <pallas@meraki.com>
Date: Thu, 17 Jul 2014 20:57:56 -0700
Message-ID: <CAFqNYV4_yW60oKmb4edH8CQtFiyT491eWOPheBrDse9j-jCYZg@mail.gmail.com>
Subject: Linux 3.4.95 breaks LZO tests (additional pull needed)
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Derrick Pallas <derrick@pallas.us>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An LZO update was backported in Linux 3.4.95 but fails to work if
crypto tests are enabled. It turns out that
0ec7382036922be063b515b2a3f1d6
f7a607392c, which updates the test vectors, did not come along for the
ride. Thanks, ~Derrick
