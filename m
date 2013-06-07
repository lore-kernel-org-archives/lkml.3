Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab3FGK4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:56:40 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:45174 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab3FGK4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:56:37 -0400
MIME-Version: 1.0
Date: Fri, 7 Jun 2013 16:26:36 +0530
Message-ID: <CAKohpokdrw1KZuCx6Y5E1JyK-Yq0T1fh0qP+bEaqgZjoK8JEEQ@mail.gmail.com>
Subject: [GIT PULL] CPUFreq: ARM Updates for v3.11
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lists linaro-dev <linaro-dev@lists.linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

The following changes since commit d683b96b072dc4680fc74964eca77e6a23d1fa6e:

  Linux 3.10-rc4 (2013-06-02 17:11:17 +0900)

are available in the git repository at:

  git://git.linaro.org/people/vireshk/linux.git cpufreq-next

for you to fetch changes up to f13ad5d9829c060fffe5bf45b05cc3c689a2e719:

  cpufreq: kirkwood: Select CPU_FREQ_TABLE option (2013-06-07 16:21:13 +0530)

----------------------------------------------------------------
Arnd Bergmann (2):
      cpufreq: SPEAr needs cpufreq table
      cpufreq: bit.LITTLE needs cpufreq table

Ezequiel Garcia (1):
      cpufreq: kirkwood: Select CPU_FREQ_TABLE option

 drivers/cpufreq/Kconfig.arm | 3 +++
 1 file changed, 3 insertions(+)

--
Viresh
